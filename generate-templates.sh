#!/usr/bin/env bash

HEADER_FOOTER_DELIMITER='content-goes-here'

TEMPLATE_LAYOUT_PATH='./templates/layout.html'
TEMPLATE_404_PATH='./templates/404.html'

OUTPUT_HEADER_PATH='./theme/header.html'
OUTPUT_FOOTER_PATH='./theme/footer.html'
OUTPUT_404_PATH='./static/404.html'

declare -A PLACEHOLDERS_DEFAULT=(
  ['{{site_title}}']='Index'
  ['{{site_heading}}']='Files'
  ['{{site_subheading}}']='Directory Index'
  ['{{site_heading_attributes}}']='class="site-title" data-directory-title aria-live="polite"'
  ['{{main_class}}']='index-card'
  ['{{main_aria_label}}']='Directory listing'
)

declare -A PLACEHOLDERS_404=(
  ['{{site_title}}']='404 - Not Found'
  ['{{site_heading}}']='404'
  ['{{site_subheading}}']='not found'
  ['{{site_heading_attributes}}']='class="site-title"'
  ['{{main_class}}']='index-card not-found-card'
  ['{{main_aria_label}}']='Not found'
)

substitute_placeholders() {
  if [[ "${1-}" == "404" ]]; then
    local -n dict=PLACEHOLDERS_404
  else
    local -n dict=PLACEHOLDERS_DEFAULT
  fi
  local content
  content=$(<"$TEMPLATE_LAYOUT_PATH")

  for k in "${!dict[@]}"; do
    content=${content//"$k"/"${dict[$k]}"}
  done
  printf '%s' "$content"
}

generate_header_footer() {
  awk \
    -v header="$OUTPUT_HEADER_PATH" \
    -v footer="$OUTPUT_FOOTER_PATH" \
    -v token="$HEADER_FOOTER_DELIMITER" '
  $0 ~ token { seen=1; next }
  { print > (seen ? footer : header) }
  '
}

generate_404() {
  local INDENT_SIZE=8
  awk \
    -v file="$TEMPLATE_404_PATH" \
    -v indent="$INDENT_SIZE" \
    -v out="$OUTPUT_404_PATH" \
    -v token="$HEADER_FOOTER_DELIMITER" '
  BEGIN {
    pad=""
    for(i=0;i<indent;i++) pad=pad" "
    while ((getline line < file) > 0) {
      repl = repl pad line ORS
    }
    close(file)
  }

  {
    if ($0 ~ token) {
      printf "%s", repl >> out
    } else {
      print >> out
    }
  }
  '
}

rm -f "$OUTPUT_FOOTER_PATH" "$OUTPUT_HEADER_PATH" "$OUTPUT_404_PATH"

substitute_placeholders | generate_header_footer
substitute_placeholders 404 | generate_404
