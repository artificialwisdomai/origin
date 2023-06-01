while [ true ]
  do
  echo -n "trying AD-1: "

  if [ "$(terraform plan -var availability_domain='zyFb:PHX-AD-1' -out bm.tfplan >& /dev/null && terraform apply bm.tfplan >& /dev/null; echo $?)" -eq "0" ]
    then
    echo success!
    break
  else
    echo -n "trying AD-3: "
    if [ "$(terraform plan -var availability_domain='zyFb:PHX-AD-3' -out bm.tfplan >& /dev/null && terraform apply bm.tfplan >& /dev/null; echo $?)" -eq "0" ]
      then
      echo success!
      break
    else
      slp=$(( $RANDOM%60 ))
      echo sleeping for $slp seconds
      sleep $slp
    fi
  fi
  done