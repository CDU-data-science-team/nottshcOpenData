#' Connect to MySQL
#'
#' @description MySQL needs to be installed, see https://dev.mysql.com/downloads/ for more information.
#'
#' @param driver String, default is set to "MySQL ODBC 8.0 Unicode Driver"
#' @param server String, specifying the server address. The default value is correct-
#' an argument is provided in case we ever move the server
#' @param UID String, specifying the 'user id'. Defaults to "opendata" which is a special
#' user who can see the open data only. If you have your own account set it with
#' Sys.setenv("UID_MYSQL_SUCE" = "user.name")
#' @param PWD String, specifying SUPER secure personal password. Defaults to "letmein" which
#' is the open data user password You can set this using
#' Sys.setenv("PWD_MYSQL_SUCE" = "SECRET_PASSWORD")
#' @param Port Numeric, default is set to 3306
#' @param database String, default is set to "SUCE"
#'
#' @section Last updated by:
#' Chris Beeley
#' @section Last updated date:
#' 2021-04-03
#'
#' @return
#' @export
connect_mysql <- function(driver    = "MySQL ODBC 8.0 Unicode Driver",
                          server    = "109.74.194.173",
                          UID       = "opendata",
                          PWD       = "letmein",
                          Port      = 3306,
                          database  = "SUCE",
                          open_data = FALSE) {

  if(!open_data){

    check_server <- ""

    if (check_server == "") {

      message("No host name set, using default ...")

    } else {

      server <- check_server
    }

    check_UID <- ""

    if (check_UID == "") {

      message("No UID_MYSQL_SUCE set, defaulting to 'opendata' ...")

    } else {

      UID <- check_UID
    }

    check_PWD <- ""

    if (check_PWD == "") {

      message("No PWD_MYSQL_SUCE set, defaulting to 'letmein' ...")

    } else {

      PWD <- check_PWD
    }
  }

  conn <- try(pool::dbPool(drv = odbc::odbc(),
                            driver = driver,
                            server = server,
                            UID = UID,
                            PWD = PWD,
                            database = database,
                            Port = Port))

  if ("try-error" %in% class(conn)) {

    cli::cli_div(theme = list(span.emph = list(color = "red")))
    cli::cli_h1("Connecting to {driver}")
    cli::cli_alert_danger("Failed to connect to server: {.emph {server}}")
    cli::cli_alert_danger("Failed to connect to database: {.emph {database}}")
    cli::cli_alert_info("Check your login credentials in the function arguments of in your environment variables.
                         You may also need to install MySQL drivers https://dev.mysql.com/downloads/connector/odbc/, see description for more information.")
    cli::cli_end()

  } else {

    cli::cli_div(theme = list(span.emph = list(color = "green")))
    cli::cli_h1("Connecting to {driver}")
    cli::cli_alert_success("Connecting to server: {.emph {server}}")
    cli::cli_alert_success("Connecting to database: {.emph {database}}")
    cli::cli_end()

    return(conn)

  }

}
