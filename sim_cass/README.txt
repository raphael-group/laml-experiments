
# first run
python cass.py -n 150 -m 30 -r 30 -s 0 -p 0.1 -d 0.1 -z 0.1 -o n150_m30_bothmissing

# second run
python cass.py -n 150 -m 30 -r 30 -s 0 -p 0.1 -d 0.1 -z 0 -o n150_m30_noheritable

# third run
python cass.py -n 150 -m 30 -r 30 -s 0 -p 0.1 -d 0 -z 0.1 -o n150_m30_nodropout

# fourth run
python cass.py -n 150 -m 30 -r 30 -s 0 -p 0.1 -d 0 -z 0 -o n150_m30_nomissing
