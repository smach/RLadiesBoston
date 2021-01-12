if(!(require(pacman))) {
  install.packages("pacman")
}

pacman::p_load(xaringan, icon, DT, reactable, sparkline, dplyr, rio, glue, htmltools, htmlwidgets )
