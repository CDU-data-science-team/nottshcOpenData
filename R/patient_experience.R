#' Get patient experience data from MySQL (in the cloud)
#'
#' @description Note that you will need to configure Sys.getenv("UID_MYSQL_SUCE"),
#' and Sys.getenv("PWD_MYSQL_SUCE") or use open_data = TRUE to retrieve
#' the public dataset
#'
#' @param from String, specifying start date in "YYYY-MM-DD" format
#' @param to String, specifying end date in "YYYY-MM-DD" format
#' @param remove_demographics Logical, specifying whether to remove
#' demographic features (which must NOT be open sourced) (TRUE)
#' or leave them in (FALSE).
#' @param conn A database connection- by default done automatically
#' @param open_data Logical, indicating whether you want to use the pre-cleaned
#' open dataset that contains no demographic information or responses where the
#' respondent opted out of sharing. Setting to FALSE requires an authenticated
#' account
#' @param remove_optout Logical, specifying whether you want to remove people
#' who opted out of sharing. This MUST be done if data is shared. The open dataset
#' does not contain any opt outs, for this reason
#'
#' @section Last updated by:
#' Chris Beeley
#' @section Last updated date:
#' 2021-05-11
#'
#' @return
#' @export
get_px_exp <- function(from = NULL,
                       to = NULL,
                       remove_demographics = TRUE,
                       conn = conn_mysql_suce,
                       open_data = TRUE,
                       remove_optout = TRUE) {

  # Create connection to table

  if (!exists("conn_mysql_suce")) {

    assign("conn_mysql_suce", connect_mysql(database = "SUCE"), envir = globalenv())

  }

  if (open_data) {

    db_data <- dplyr::tbl(conn, dbplyr::in_schema("SUCE", "OpenLocal"))

    db_data <- dplyr::tbl(conn, dplyr::sql(
      "SELECT OpenLocal.*, Teams.Inpatient, Teams.fftCategory, Teams.TeamN,
      Directorates.DirT, Directorates.Division2
      FROM OpenLocal INNER JOIN Teams
      INNER JOIN Directorates ON Directorates.DirC = Teams.Directorate
      WHERE OpenLocal.TeamC = Teams.TeamC
      AND OpenLocal.Date >= Teams.date_from
      AND OpenLocal.Date <= Teams.date_to
      AND OpenLocal.Date >= Directorates.date_from
      AND OpenLocal.Date <= Directorates.date_to")
    )

  } else {

   stop("This option not availble in the public version version.", call. = FALSE)

    if (remove_demographics) {

      stop("This option not availble in the public version version.", call. = FALSE)

    }
  }

  # Filter date range
  if (!is.null(from)) {

    db_data <- db_data %>%
      dplyr::filter(Date >= from)
  }

  if (!is.null(to)) {

    db_data <- db_data %>%
      dplyr::filter(Date <= to)
  }

  # Return
    return(db_data)

}

#' Tidy patient experience data
#'
#' @param data dataframe or SQL object, that you can make with get_px_exp()
#' @param conn connection, that you can make with connect_mysql()- by default
#' this will be done automatically
#'
#' @return
#' @export
#'
#' @section Last updated by:
#' Chris Beeley
#' @section Last updated date:
#' 2021-04-25
tidy_px_exp <- function(data, conn = conn_mysql_suce) {

  # get the codes db connection
  db_codes_exp_data <- dplyr::tbl(conn, dbplyr::in_schema("SUCE", "NewCodes")) %>%
    dplyr::rename_all(janitor::make_clean_names)

  # TIDY FUNCTION HERE
  db_tidy <- data %>%
    dplyr::rename_all(janitor::make_clean_names) %>%
    dplyr::mutate_at(c("imp_n1", "imp_n2", "best_n1", "best_n2"), toupper) %>%
    dplyr::rename(imp = improve,
                  directorate = dir_t, division = division2) %>%
    dplyr::mutate(dplyr::across(service : positive, ~ case_when(
      . %in% 0 : 5 ~ .,
      TRUE ~ NA_integer_))) %>%
    tidyr::pivot_longer(cols = c("imp", "best"),
                        names_to = "comment_type",
                        values_to = "comment_txt") %>%
    tidyr::pivot_longer(cols = c(imp_n1, imp_n2, best_n1, best_n2),
                        names_to = c("type_category", "type_num"), names_sep = "_",
                        values_to = "code") %>%
    dplyr::mutate(code = na_if(code, "XX")) %>%
    dplyr::filter((comment_type == "imp" & type_category == "imp") |
                    (comment_type == "best" & type_category == "best")) %>%
    dplyr::mutate(crit = case_when(comment_type == "imp" ~ imp_crit * -1,
                                   comment_type == "best" ~ best_crit)) %>%
    dplyr::select(-c(imp_crit, best_crit)) %>%
    dplyr::mutate(crit = dplyr::case_when(
      crit %in% -5 : 5 ~ crit,
      TRUE ~ NA_integer_
    )) %>%
    dplyr::left_join(db_codes_exp_data,
                     by = c("code")) %>%
    dplyr::mutate(comment_key = paste0(key, "_", type_category)) %>%
    dplyr::select(key, comment_key, date, location, team_c, team_n,
                  directorate, division,
                  su, service, listening, communication, respect, inv_care,
                  positive,
                  category = category,
                  subcategory = subcategory,
                  comment_type : crit,
                  any_of(c("optout", "gender", "ethnic", "disability",
                         "religion", "sexuality", "age", "relationship",
                         "pregnant", "baby")))

  # Return
  return(db_tidy)

}
