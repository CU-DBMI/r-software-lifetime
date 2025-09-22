#' Parse OSV Response
#' 
#' Parse the response from Open Source Vulnerabilities (OSV) to extract relevant information
#' into a tibble for analysis or display.
#' 
#' @param vuln_list A list of OSV vulnerability response objects
#' 
#' @return A tibble with the parsed information
.parse_osv_resp <- function(vuln_list) {
  vulns <- vuln_list |>
    purrr::map_dfr(function(v) {
      affected_df <- v$affected |>
        purrr::map_df(function(a) {
          tibble::tibble(
            pkg_name   = a$package$name,
            ecosystem  = a$package$ecosystem,
            introduced = purrr::map_chr(a$ranges[[1]]$events, "introduced", .default = NA),
            fixed      = purrr::map_chr(a$ranges[[1]]$events, "fixed", .default = NA),
            urgency = a$ecosystem_specific$urgency %||% NA_character_
          )
        })
      
      tibble::tibble(
        id        = v$id,
        published = v$published,
        modified  = v$modified,
        urgency    = affected_df$urgency |> unique() |> paste(collapse = "; "),
        introduced = affected_df$introduced |> suppressWarnings(as.numeric_version(.)) |> min(na.rm = TRUE),
        fixed      = affected_df$fixed |> suppressWarnings(as.numeric_version(.)) |> max(na.rm = TRUE),
        details   = v$details, 
        references = v$references |>
          purrr::map_chr(~ .x$url) |>
          paste(collapse = "; ")
      )
    })
}


#' Query OSV
#' 
#' Open Source Vulnerabilities (OSV) enables developers to identify known third-party open source 
#' dependency vulnerabilities that pose genuine risk to their application and its environment, so 
#' they can focus remediation efforts on the vulnerabilities that matter and sustainably manage 
#' vulnerabilities that do not affect them.
#'
#' @param name Name of the package
#' @param ecosystem Ecosystem of the package
#'
#' @importFrom httr2 request req_body_json req_perform resp_body_json
#' 
#' @return A tibble with vulnerability information about the requested package. 
#' 
#' @references https://google.github.io/osv.dev/api/
#' @examples 
#' vulns <- query_osv(name = 'r-base', ecosystem = 'Debian')
#' str(vulns, max.level = 1)

query_osv <- function(name = 'r-base', ecosystem = 'Debian') {
  ## Input Validation
  if (is.null(name) || is.null(ecosystem)) {
    stop("name and ecosystem cannot be null")
  }

  ## POST
  req <- httr2::request("https://api.osv.dev/v1/query") |>
    httr2::req_body_json(list(
      package = list(
        name = name,
        ecosystem = ecosystem
      )
    ))
  ## JSON Response
  resp <- req |>
    httr2::req_perform()

  if (resp$status_code != 200) {
    stop(paste0("Request to OSV failed with status code ", resp$status_code))
  }

  resp <- resp |>
    httr2::resp_body_json()

  .parse_osv_resp(resp$vulns)
}
  