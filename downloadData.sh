#!/bin/bash
rm -rf ../output/*
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/data_n_section_x_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/data_v_section_x_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/data_e_section_x_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/data_E_section_x_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/theory/theory_e_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/theory/theory_E_* ../output/ &
scp mgalazyn@tesla.if.pw.edu.pl:~/tools/script/sim1/theory/theory_v_* ../output/ &

echo "Waiting for all scp processes..."
while [ `ps -U $USER -u $USER u | grep scp | wc -l` != 1 ]; do
  sleep 0.5
done
