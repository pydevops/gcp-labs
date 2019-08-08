package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"database/sql"

	_ "github.com/lib/pq"
)

func handler(w http.ResponseWriter, r *http.Request) {
	log.Print("Hello world received a request.")
	target := os.Getenv("TARGET")
	if target == "" {
		target = "World"
	}
	fmt.Fprintf(w, "Hello %s!\n", target)

	// Get a list of the most recent visits.
	// visits, err := queryVisits(10)
	// if err != nil {
	// 	msg := fmt.Sprintf("Could not get recent visits: %v", err)
	// 	http.Error(w, msg, http.StatusInternalServerError)
	// 	return
	// }

	// // Record this visit.
	// if err := recordVisit(time.Now().UnixNano(), r.RemoteAddr); err != nil {
	// 	msg := fmt.Sprintf("Could not save visit: %v", err)
	// 	http.Error(w, msg, http.StatusInternalServerError)
	// 	return
	// }

	// fmt.Fprintln(w, "Previous visits:")
	// for _, v := range visits {
	// 	fmt.Fprintf(w, "[%s] %s\n", time.Unix(0, v.timestamp), v.userIP)
	// }
	// fmt.Fprintln(w, "\nSuccessfully stored an entry of the current request.")

}

var (
	db             *sql.DB
	connectionName = os.Getenv("host")
	dbUser         = os.Getenv("user")
	dbPass         = os.Getenv("password")
	dbname         = os.Getenv("db")
	dsn            = fmt.Sprintf("sslmode=disable host=/cloudsql/%s user=%s password=%s dbname=%s", connectionName, dbUser, dbPass, dbname)
)

func main() {
	log.Print("sql started.")

	var err error
	db, err = sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("Could not open db: %v", err)
	}
	defer db.Close()
	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	// Only allow 1 connection to the database to avoid overloading it.
	db.SetMaxIdleConns(1)
	db.SetMaxOpenConns(1)

	// Ensure the table exists.
	// Running an SQL query also checks the connection to the PostgreSQL server
	// is authenticated and valid.
	if err := createTable(); err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", handler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}

func createTable() error {
	stmt := `CREATE TABLE IF NOT EXISTS visits (
			timestamp  BIGINT,
			userip     VARCHAR(255)
		)`
	_, err := db.Exec(stmt)
	return err
}

type visit struct {
	timestamp int64
	userIP    string
}

func recordVisit(timestamp int64, userIP string) error {
	stmt := "INSERT INTO visits (timestamp, userip) VALUES ($1, $2)"
	_, err := db.Exec(stmt, timestamp, userIP)
	return err
}

func queryVisits(limit int64) ([]visit, error) {
	rows, err := db.Query("SELECT timestamp, userip FROM visits ORDER BY timestamp DESC LIMIT $1", limit)
	if err != nil {
		return nil, fmt.Errorf("Could not get recent visits: %v", err)
	}
	defer rows.Close()

	var visits []visit
	for rows.Next() {
		var v visit
		if err := rows.Scan(&v.timestamp, &v.userIP); err != nil {
			return nil, fmt.Errorf("Could not get timestamp/user IP out of row: %v", err)
		}
		visits = append(visits, v)
	}

	return visits, rows.Err()
}
