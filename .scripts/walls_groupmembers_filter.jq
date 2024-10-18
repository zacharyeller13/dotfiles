# Useful for filtering logs from Web Service Load Errors table logging
# Run with --slurp option
# Provide script via --from-file option
map(
    select(.Response_Body != null)
    | .Response_Body
    | fromjson 
    | select(.[].errorType != "Duplicate")
) as $responseErrors
| map(
    select(.Response_Body == null)
    | {File_Name, Error_Message}
) as $errorMessages
| $responseErrors, $errorMessages
