# gimbal [![Build Status](https://travis-ci.org/pacso/gimbal.svg?branch=master)](https://travis-ci.org/pacso/gimbal) [![Gem Version](https://badge.fury.io/rb/gimbal.svg)](https://badge.fury.io/rb/gimbal) [![Dependency Status](https://gemnasium.com/badges/github.com/pacso/gimbal.svg)](https://gemnasium.com/github.com/pacso/gimbal)


Gimbal is the base Rails application I use when starting new projects. It was mostly copied from thoughtbot's Suspenders project, but modified for my needs.

## Installation

Install the `gimbal` gem:

    gem install gimbal

Then use it:

    gimbal projectname

This will create a Rails app in `projectname` directory using the latest version of Rails.

## Git

You can optionally create a GitHub repository for your new Rails app. It requires that you have Hub on your system:

    curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    gimbal app --github organisation/project

Which does the same thing as running:

    hub create organisation/project
