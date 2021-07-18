.onAttach <- function(libname, pkgname) {
  version <- read.dcf(file = system.file("DESCRIPTION", package = pkgname),
                      fields = "Version")
  cli::cli_h1(paste0("This is ", pkgname, " ", version))
  cli::cli_alert_info(paste0(pkgname, " is currently in development, please report any bugs or ideas at:"))
  cli::cli_alert_info("https://github.com/CDU-data-science-team/nottshcOpenData/issues")

  cli::cli_h1("Connecting to NOTTSHC SUCE Server:")
  cli::cli_text('conn_mysql_suce <- connect_mysql(database = "SUCE")')
}
