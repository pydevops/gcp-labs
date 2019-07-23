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