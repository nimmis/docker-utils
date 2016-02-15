#!/bin/sh

shutdown() {
  echo Shutting Down Container

  # running shutdown commands
  /etc/runit/3
 
  # first shutdown any service started by runit
  for _srv in $(ls -1 /etc/service); do
    echo "sv force-stop $_srv"
  done

  # shutdown runsvdir command  
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR

  # give processes time to stop
  sleep 0.5

  # kill any other processes still running in the container

  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$'); do
    timeout -t 5 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done

}

# run pre-deamon tasks
/etc/runit/1

# start all deamons
/etc/runit/2&

RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
# catch shutdown signals
trap shutdown SIGTERM SIGHUP
wait $RUNSVDIR

shutdown
