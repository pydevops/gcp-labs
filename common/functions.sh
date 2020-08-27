# Check if gcloud is installed and on the path
command -v gcloud >/dev/null 2>&1 || \
  { echo >&2 "I require gcloud but it's not installed. Aborting.";exit 1; }


# Check if all required variables are non-null
# Globals:
#   None
# Arguments:
#   VAR - The variable to check
# Returns:
#   None
variable_is_set() {
  if [[ -z "${VAR}" ]]; then
    echo "Variable is not set. Please check your istio.env file."
    return 1
  fi
  return 0
}

# Check if required binaries exist
# Globals:
#   None
# Arguments:
#   DEPENDENCY - The command to verify is installed.
# Returns:
#   None
dependency_installed () {
  command -v "${1}" >/dev/null 2>&1 || exit 1
}

# Helper function to enable a given service for a given project
# Globals:
#   None
# Arguments:
#   PROJECT - ID of the project in which to enable the API
#   API     - Name of the API to enable, e.g. compute.googleapis.com
# Returns:
#   None
enable_project_api() {
  gcloud services enable "${2}" --project "${1}"
}


# set PROJECT_ID
PROJECT_ID=$(gcloud config list project --format 'value(core.project)')
if [ -z "${PROJECT_ID}" ]
  then echo >&2 "I require default project is set but it's not. Aborting."; exit 1;
fi

# set PROJECT_NUMBER
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
      --format="value(projectNumber)")
#PROJECT_NUMBER="$(gcloud projects describe ${PROJECT_ID} --format='get(projectNumber)')"
#PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT" --format="value(PROJECT_NUMBER)" --project=$PROJECT)