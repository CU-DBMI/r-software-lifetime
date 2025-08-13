<!-- README.md is generated from README.Rmd. Please edit that file and render with `rmarkdown::render("README.Rmd", output_format = rmarkdown::md_document(variant = "gfm"))`
-->

# r-software-lifetime

<!-- badges: start -->

<!-- badges: end -->

This repository hosts the code for rendering a [Quarto
website](https://quarto.org/docs/websites/) that provides a quick
visualization of the lifespans of different R versions.

While the underlying information exists elsewhere on the web, summarized
and glanceable details are often scattered. This attempts to consolidate
the information into one place with help from the [rversions
package](https://cran.r-project.org/package=rversions).

View the site here: <https://cu-dbmi.github.io/r-software-lifetime>

Visitors can click “Show the code” on the site to view the code used to
generate each section.

## How it works

- Data source: [rversions
  package](https://cran.r-project.org/package=rversions), which provides
  release history for R.
- Visualization: Plotly charts and DT datatables summarizing version
  lifespans.
- Transparency: Each section includes a “Show the code” button so
  readers can see exactly how the output was generated.

## Local build

To build the site locally:

### Clone the repo

    git clone https://github.com/CU-DBMI/r-software-lifetime.git
    cd r-software-lifetime

### Set up R environment with `renv`

This project uses `renv` for reproducible R package management.

``` r
install.packages("renv") # if not already installed
renv::restore()
```

### Render the Quarto site

Ensure Quarto is installed: <https://quarto.org/docs/get-started/>

    quarto render

The rendered site will be output to the `docs` directory.

## Contributing

Pull requests to improve the code, visuals, or documentation are
welcome. Please open issues to discuss proposed changes.
