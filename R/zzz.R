.onAttach <- function(libname, pkgname) {
  version <- read.dcf(file = system.file("DESCRIPTION", package = pkgname),
                      fields = "Version")
  cli::cli_text(paste0("This is ", pkgname, " ", version))
  cli::cli_text(paste0(pkgname, " is currently in development - please report any bugs or ideas at:"))
  cli::cli_text("https://github.com/CDU-data-science-team/nottshcPublic/issues")

  cli::cli_h1("Connecting to nottshc servers:")
  cli::cli_alert_info('conn_mysql_suce <- connect_mysql(database = "SUCE")')
}
