#!/bin/bash

function echo_bold_italic_underline() {
  echo -e "\e[3m\e[1m\e[4m$1\e[0m"
}
