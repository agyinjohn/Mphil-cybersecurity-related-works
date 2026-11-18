#!/usr/bin/env bash
# Compile the thesis markdown files into a single Word document.
set -euo pipefail
cd "$(dirname "$0")"
pandoc Preliminaries.md \
  Chapter_1_Introduction.md \
  Chapter_2_Literature_Review.md \
  Chapters_3_4_5_Skeleton.md \
  References.md \
  -o Thesis_Draft.docx
pandoc 00_Base_Paper_Critical_Review_and_Gaps.md -o Base_Paper_Gap_Analysis.docx
echo "Built Thesis_Draft.docx and Base_Paper_Gap_Analysis.docx"
pandoc Examiner_Style_Review_of_Dual_Stream_Thesis.md -o Examiner_Style_Review.docx && echo "Built Examiner_Style_Review.docx"
