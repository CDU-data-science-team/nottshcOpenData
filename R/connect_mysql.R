#' Connect to MySQL
#'
#' @description You may need to set up ODBC Drivers on your computer prior to
#' using this function, see https://db.rstudio.com/best-practices/drivers/.
#' If you cant connect to the database and get lost in endless and frustrating
#' errors with no solution, download the package praise `install.packages("praise")`
#' and run the following function `praise::praise()` until you feel better again
#' -- and file an issue.
#'
#' @param driver String, default is set to "MySQL ODBC 8.0 Unicode Driver", on Mac this may have to be changed to "MySQL ODBC 8.0 ANSI Driver",
#' In case these options don't work, it may help to check the installed database drivers on your computer using `odbc::odbcListDrivers()`.
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
#' Milan Wiedemann
#' @section Last updated date:
#' 2021-07-18
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

    # Assign empty string for this package, usually check Sys.getenv()
    check_server <- ""

    if (check_server == "") {

      cli::cli_div(theme = list(span.emph = list(color = "green")))
      cli::cli_alert_info("No host name set, using default server: {.emph {server}}")

    } else {

      server <- check_server
    }

    # Assign empty string for this package, usually check Sys.getenv()
    check_UID <- ""

    if (check_UID == "") {

      cli::cli_alert_info("No UID set, using default UID: {.emph {UID}}")

    } else {

      UID <- check_UID
    }

    check_PWD <- ""

    if (check_PWD == "") {

      cli::cli_alert_info("No PWD set, using default PWD: {.emph {PWD}}")

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

    # This isnt the best way to do it but going for quick implementation here
    # Needs to be improved later
    conn <- try(pool::dbPool(drv = odbc::odbc(),
                             driver = "MySQL ODBC 8.0 ANSI Driver",
                             server = server,
                             UID = UID,
                             PWD = PWD,
                             database = database,
                             Port = Port))

  }

  if ("try-error" %in% class(conn)) {

    cli::cli_div(theme = list(span.emph = list(color = "red")))
    cli::cli_h1("Connecting to {driver}")
    cli::cli_alert_danger("Failed to connect to server: {.emph {server}}")
    cli::cli_alert_danger("Failed to connect to database: {.emph {database}}")
    cli::cli_alert_info("Check your login credentials in the function arguments of in your environment variables.")
    cli::cli_alert_info("You may also need to install MySQL drivers https://dev.mysql.com/downloads/connector/odbc/, see description for more information.")
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
