# Updating R and RStudio
Beth Jump
2025-06-12

## Overview

It’s important to update both your R software and your RStudio IDE
periodically. Updating your R software ensures that you’re able to use
the newest versions of packages that have been released and that your
code and functions stay current and able to be shared easily. If you
don’t update your R software for a long time (\>2-3 years) you might end
up with code that is written that doesn’t work on a current version of
R.

You don’t have to update R and RStudio at the same time. R tends to
release a major version (ex: 4.5.0) every April or May and releases
minor versions (ex: 4.5.1, 4.5.2, etc) throughout the year. RStudio
seems to release new updates every 3 months or so.

## Checking current versions

### R

When you open R or RStudio, the R version is listed in the first line of
the text in the console. You can also check by running `getRversion()`
from the console.

### RStudio

If you go to Help \> About RStudio, your version of RStudio should be
listed right at the top of the window. You can check to see if an update
is available from Help \> Check for Updates.

## Steps for updating R and RStudio

Updating R and RStudio involves downloading new versions of R and
RStudio and installing the packages you need. If possible, you should do
the steps in the order below as it will ensure that your new RStudio
installation will look to your new R installation to run code from.

1.  Install a new version of R.
    - You can download the newest version of R
      [here](https://cran.rstudio.com/). Just click the hyperlink at the
      top that says **Download R-4.X.X for Windows**.
    - You can download this even if you don’t have admin rights and it
      should work though it will be installed in a different location
      (not in Program Files).
2.  Install packages in your new version of R.
    - If you have admin rights you should do this in the actual R
      application because you can run it as an administrator and install
      packages directly onto the computer you’re using. If you don’t
      have admin rights, you can do this in the R or RStudio
      application.
    - To get to the R application go to C:/Program Files/R. Open the
      folder with your new installation of R (ex: R-4.5.0) and go to the
      **bin** folder. Right click on the **R.exe** application and run
      it as an administrator.  
    - We have a
      [script](https://github.com/San-Mateo-County-Health-Epidemiology/Helpful-Code-Bits/blob/main/R/packages-to-install-with-new-R-installation.R)
      with a running list of packages we commonly use that you should
      install when you get a new version of R. Please feel free to add
      any packages we’ve missed to this script!
3.  Install new version of RStudio
    - You need admin rights to do this
    - Download the newest version
      [here](https://posit.co/download/rstudio-desktop/)

## Updating the version of R used in RStudio

By default, RStudio should use the newest version of R that is installed
on your computer. You can check this and change this by going to Tools
\> Global Options.
