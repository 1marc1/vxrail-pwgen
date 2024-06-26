#!/bin/bash
# Program: vxrail-pwgen.sh
# Language: bash
# License: MIT (license details at the end of this file)
# Copyright: 2024 Marc van Wieringen, Sydney, Australia
version="2.1, 26 June 2024"
program=`basename "${0}"`

# Script that generates random passwords that meet VxRail requirements.

######
# Version 2.1 (26 June 2024) of this script incorporates Dell ToR and Management switches.
# https://www.dell.com/support/manuals/en-au/smartfabric-os10-emp-partner/smartfabric-os-user-guide-10-5-1/username-password-role?guid=guid-8919dff1-da0d-4db8-b750-a89a737bcd58&lang=en-us

# SmartFabric OS 10 username: admin
# SmartFabric OS 10 password: 
# Comments: 
# Username: Minimum of 1 character, maximum of 32 characters
# Password: Minimum 9 characters, maximum 32 characters.

######
# Version 1.x (April 2024) of this script incorporates requirements listed here:
# https://www.dell.com/support/kbdoc/en-au/000081763

######
# Version 2.0 (24 June 2024) of this script adds checks found from the following locations:
# https://www.dell.com/support/kbdoc/en-au/000158231
# https://www.dell.com/support/kbdoc/en-au/000056555
# https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-esxi-upgrade/GUID-DC96FFDB-F5F2-43EC-8C73-05ACDAE6BE43.html
# https://www.dell.com/support/manuals/en-au/idrac9-lifecycle-controller-v5.x-series/idrac9_security_configuration_guide/password-strength-policy?guid=guid-eec1111b-8444-40cf-9e7b-84779c5b066d&lang=en-us
#
# There are contradictions in the KBdocs listed above. This program aims
# to provide you with valid details, but there are no guarantees!
#
# Using this method of generating VxRail passwords ensures that all characters
# used in a password can be safely passed during upgrade scripts.


# As per 18 June 2024, based on the information provided on the above websites,
# the following information is known about the accounts and their passwords.

# In general, the only special characters allowed, erring on the safe side are:
#                         + , - . : @ ] _ { }
# This is because the `vxverify` script (which you should run before upgrading)
# checks passwords for containing possible offending special characters.
# By limiting passwords to only include the listed special characters, the
# `vxverify` script should not fail on this step.

# VMware vCenter Server root username: root
# VMware vCenter Server root password: 
# Comments: Creation of this account only happens by the VxRail Deployment Wizard when using a VxRail Managed vCenter Server.
#           Username must be _root_
# Password: MUST BE THE SAME AS THE VCENTER SERVER ADMINISTRATOR PASSWORD
#           As a result:
#           * Minimum 8 characters, maximum 20 characters.
#           * At least one uppercase, one lowercase and one special character.


# vCenter Server administrator username: administrator@vsphere.local
# vCenter Server administrator password:
# Comments: When using a VxRail Managed vCenter Server, the username needs to be administrator@vsphere.local; in this situation this account is created by the VxRail Deployment Wizard.
#           When an external vCenter Server is used, it should be the equivalent of the administrator@vsphere.local account of the vCenter Server you are connecting to.
# Password: Minimum 8 characters, maximum 20 characters.
#           At least one uppercase, one lowercase and one special character.
#           MUST BE THE SAME AS THE VCENTER SERVER ROOT PASSWORD


# vCenter Server management username: ...@vsphere.local
# vCenter Server management password:
# Comments: When using a VxRail Managed vCenter Server, the username needs to be in _vsphere.local_ domain.
#           When using an exteral vCenter Server, this username needs to exist, with no permissions or groups assigned.
#           This user will get the _VMware HCIA Management_ permission assigned.
# Username: Length must be less than or equal to 16 characters.
#           Uppercase and lowercase letters are allowed.
#           Numerical digits are allowed.
#           The only special characters that are allowed are '-' and '_'.
# Password: Minimum 8 characters, maximum 20 characters.
#           At least one uppercase, one lowercase and one special character.


# ESXi Management username: 
# ESXi Management password:
# Comments: Account receives administrative permissions and is part of the _localos_ domain of each host.
#           You can set the password to be the same or different for each host.
#           It is recommended to ensure the username is the same for each host.
# Password: Minimum 7 characters, maximum 39 characters.
#           Must not contain dictionary words.
#           Must not contain the user name or parts of the user name.
#           Must include a mix of at least three from the following character classes: lowercase, uppercase, number, special


# ESXi root username: root
# ESXi root password:
# Comments: Username must be _root_
#           You can set the password to be the same or different for each host.
# Password: Minimum 7 characters, maximum 39 characters.
#           Must not contain dictionary words.
#           Must not contain the user name or parts of the user name.
#           Must include a mix of at least three from the following character classes: lowercase, uppercase, number, special


# VxRail Manager root username: root
# VxRail Manager root password:
# Comments: Username must be _root_
# Password: No information available online.
#           Details are contained in `/etc/pam.d/common-password`.
#           The *minlen* is not specified in this file (VxRail Manager VM 8.0.200).
#           Therefore, the minimum length is 6 characters.
#           Other values in the *common-password* file dictate the following:
#           * Minimum 1 digit.
#           * Minimum 1 uppercase.
#           * Minimum 1 lowercase.
#           * Minimum 1 special.
#           * A new password needs to have a minimum of 8 character changes compared to the old password.


# VxRail Manager service account username: mystic
# VxRail Manager service account password:
# Comments: Username must be _mystic_
#           Password needs to be different from *service* account (next one)
# Password: No information available online.
#           Details are contained in `/etc/pam.d/common-password`.
#           The *minlen* is not specified in this file (VxRail Manager VM 8.0.200).
#           Therefore, the minimum length is 6 characters.
#           Other values in the *common-password* file dictate the following:
#           * Minimum 1 digit.
#           * Minimum 1 uppercase.
#           * Minimum 1 lowercase.
#           * Minimum 1 special.
#           * A new password needs to have a minimum of 8 character changes compared to the old password.


# VxRail Manager remote service account username: service
# VxRail Manager remote service account password:
# Comments: Username must be _service_
#           Password needs to be different from *mystic* account (previous one)
# Password: No information available online.
#           Details are contained in `/etc/pam.d/common-password`.
#           The *minlen* is not specified in this file (VxRail Manager VM 8.0.200).
#           Therefore, the minimum length is 6 characters.
#           Other values in the *common-password* file dictate the following:
#           * Minimum 1 digit.
#           * Minimum 1 uppercase.
#           * Minimum 1 lowercase.
#           * Minimum 1 special.
#           * A new password needs to have a minimum of 8 character changes compared to the old password.


# iDRAC username: root
# iDRAC password:
# Comments: Username must be _root_
# Password: No specific default password policy exists for iDRAC.
#           The default setting is known as "1 - Weak protection".
#           Internet reseach shows there are indications that there is an upper limit of 20 characters.


####################### IMPORTANT ADDITIONAL INFORMATION #######################

# The passwords for the vCenter administrator account and the vCenter and PSC
# root account should be aligned all the time. Password inconsistency leads to
# node replacement and single node addition procedure failures.

################################################################################


########################## OUTPUT EXAMPLE version 2.1 ##########################

# column -t -s'#' -N "Account description,User name,Password" -L /tmp/example1.txt
# example1.txt contains: # separated values:
# VMware vCenter Server root#root#asdfjwer

# Account description                     User name                             Password
# -----------------------------------------------------------------------------------------
# VMware vCenter Server root              root                                  asdfjwer
# VMware vCenter Server administrator     administrator@vsphere.local           sdfffewwwd
# VMware vCenter Server management        vxrm@vsphere.local (suggested name)   sdfasdf
# VxRail Manager root                     root                                  lkwjrt
# VxRail Manager service account          mystic                                wtwrtwqt
# VxRail Manager remote service account   service                               ngrtheth
# 
# Dell SmartFabric OS 10 ToR switch 1     admin                                 aslfkj
# Dell SmartFabric OS 10 ToR switch 2     admin                                 uyouy
# Dell SmartFabric OS 10 MGMT switch      admin                                 4251254w
#
# Host 1
# ESXi Management                         esximgmt (suggested name)             safwtrt
# ESXi root                               root                                  puiwt
# iDRAC                                   root                                  asdfsd
# 
# Host 2
# ESXi Management                         esximgmt (suggested name)             safwtrt
# ESXi root                               root                                  puiwt
# iDRAC                                   root                                  asdfsd
# 
# Host 3
# ESXi Management                         esximgmt (suggested name)             safwtrt
# ESXi root                               root                                  puiwt
# iDRAC                                   root                                  asdfsd

################################################################################


########## Initialise Default Values ##########

# Location of temporary file used to hold output details (shredded at end of execution)
outputfile=/tmp/vxrail-pwgen.txt

# Message to display at the end of the program
endmessage=""

# Use the following variable to set the default number of hosts in the cluster
numhosts=3

# Use the following variable to set the default password length
# Make sure this is set to a value higher than the highest value in minpwlength
# and lower than the lowest value in maxpwlength
defaultchars=10

# Set default value to say that the ESXi management (esximgmt suggested user name) passwords should be the same
esximgmtpwsame=1

# Set default value to say that the ESXi root passwords should be the same
esxirootpwsame=1

# Set default value to say that the iDRAC user (root) password should be the same
idracpwsame=1

# Set default value to say that we are not using an external vCenter Server
externalvcenter=1

# Set default value to say that the Dell switches (admin) passwords should be the same
swpwsame=1

# By default we are not including switches. When -s is specified we will include switches
# This value needs to remain at 0
includeswitches=0

# The following are all the special characters on a standard US keyboard layout.
#               `~!@#$%^&*()-_=+[{]}\|;:'",<.>/?
# These are the allowed characters (on the safe side):    + , - . : @ ] _ { }
# Let's remove those characters from all special characters.
chars='`~!#$%^&*()=[\|;"<>/?'
chars=$chars"'"
# The chars variable now holds the special characaters that are not allowed.


# The descriptions variable holds the descriptions for the user accounts.
# Adding or removing from this list has implications for the rest of this
# program, as it depends on the order and number of items.

# The the following descriptions are referenced by literal name and should
# therefore remain the same or updated throughout the script:
# * "VMware vCenter Server root"
# * "VMware vCenter Server administrator"
# * "Dell SmartFabric OS 10 ToR switch 1"
# * "Dell SmartFabric OS 10 ToR switch 2"
# * "Dell SmartFabric OS 10 MGMT switch"

# The "ESXi Management" account name signals the program that host-specific
# passwords need to be generated. This account name is referenced literally.

# The last three accounts (descriptions) need to follow each other in the order
# provided and should be at the end of the array (as these are host-specific).

declare -a descriptions=("VMware vCenter Server root" \
                         "VMware vCenter Server administrator" \
                         "VMware vCenter Server management" \
                         "VxRail Manager root" \
                         "VxRail Manager service account" \
                         "VxRail Manager remote service account" \
                         "Dell SmartFabric OS 10 ToR switch 1" \
                         "Dell SmartFabric OS 10 ToR switch 2" \
                         "Dell SmartFabric OS 10 MGMT switch" \
                         "ESXi Management" \
                         "ESXi root" \
                         "iDRAC root")

# The users variable holds the (suggested) user names.
# Ensure each entry lines up with the $descriptions variable.
# Adding or removing from this list has implications for the rest of this
# program, as it depends on the order and number of items.
declare -a users=("root" \
                  "administrator@vsphere.local" \
                  "vxrm@vsphere.local (suggested name)" \
                  "root" \
                  "mystic" \
                  "service" \
                  "admin" \
                  "admin" \
                  "admin" \
                  "esximgmt (suggested name)" \
                  "root" \
                  "root")

# The defaultpws variable holds the default passwords.
# Ensure each entry lines up with the $descriptions variable.
# Adding or removing from this list has implications for the rest of this
# program, as it depends on the order and number of items.
declare -a defaultpws=("<undefined>" \
                       "<undefined>" \
                       "<undefined>" \
                       "Passw0rd!" \
                       "VxRailManager@201602!" \
                       "<undefined>" \
                       "Dellsvcs1!" \
                       "Dellsvcs1!" \
                       "Dellsvcs1!" \
                       "<undefined>" \
                       "Passw0rd!" \
                       "calvin")

# The maxpwlength variable holds the maximum password length for the accounts.
# Ensure each entry lines up with the $descriptions variable.
declare -a maxpwlength=("20" "20" "20" "39" "39" "39" "32" "32" "32" "39" "39" "20")

# The minpwlength variable holds the minimum password length for the accounts.
# Ensure each entry lines up with the $descriptions variable.
declare -a minpwlength=("8" "8" "8" "8" "8" "8" "9" "9" "9" "7" "7" "8")

# Setting the default password length for every account
declare -a pwlength=("$defaultchars" "$defaultchars" "$defaultchars" \
                     "$defaultchars" "$defaultchars" "$defaultchars" \
                     "$defaultchars" "$defaultchars" "$defaultchars" \
                     "$defaultchars" "$defaultchars" "$defaultchars")

########## End setting default variables ##########




########## FUNCTIONS ##########

### Function that generates the compliant passwords
genpw () {
  # -c    = Include at least one capital
  # -n    = Include at least one number
  # -y    = Include at least one special
  # -s    = Generate completely random, hard-to-memorize passwords
  # -r    = Remove characters from the list
  # $char = Characters that are not allowed to be used
  # $1    = Length of passwords to generate
  # $2    = Number of passwords to generate
  pwgen -c -n -y -s -r $chars $1 $2
}


### Function that gets an index from an array ($1), based on a value ($2) in the array.
getindex () {
  array=("$@")
  value=${array[-1]}
  unset 'array[-1]'
  for i in "${!array[@]}"; do
    if [[ "${array[$i]}" = "${value}" ]]; then
      echo "${i}"
      break
    fi
  done
}


### Function to get minimum value of an array of integers
getarrmin () {
  array=("$@")
  l=${array[0]}
  for i in "${array[@]}"; do
    if [[ "$i" -lt "$l" ]]; then
      l="$i"
    fi
  done
  echo "$l"
}


### Function to get maximum value of an array of integers
getarrmax () {
  array=("$@")
  h=${array[0]}
  for i in "${array[@]}"; do
    if [[ "$i" -gt "$h" ]]; then
      h="$i"
    fi
  done
  echo "$h"
}

### Function that removes a value from the following arrays, based on an index number ($1):
### $descriptions, $users, $pwlength, $maxpwlength, $minpwlength
update_arrays () {
  for i in "${!descriptions[@]}"; do
    if [[ $i != $1 ]]; then
      new_array1+=("${descriptions[$i]}")
      new_array2+=("${users[$i]}")
      new_array3+=("${pwlength[$i]}")
      new_array4+=("${maxpwlength[$i]}")
      new_array5+=("${minpwlength[$i]}")
    fi
  done
  descriptions=("${new_array1[@]}")
  users=("${new_array2[@]}")
  pwlength=("${new_array3[@]}")
  maxpwlength=("${new_array4[@]}")
  minpwlength=("${new_array5[@]}")
  unset new_array1
  unset new_array2
  unset new_array3
  unset new_array4
  unset new_array5
}


### Function that deletes the temporary file
deltmpfile () {
  which shred > /dev/null
  if [ "$?" != "0" ]; then
    rm $outputfile > /dev/null
    if [ "$?" != "0" ]; then
      echo ""
      echo "There was an issue deleting the temporary file: $outputfile"
      echo "Also, consider installing 'shred' for more secure deletion of this file."
    else
      echo ""
      echo "The temporary file was removed via 'rm', because 'shred' is not installed."
    fi
  else
    shred -n 5 -u $outputfile > /dev/null
    if [ "$?" != "0" ]; then
      echo ""
      echo "There was an issue shredding the temporary file: $outputfile"
    fi
  fi
}


### Function to display the factory default passwords
showdefaultpws () {
  # Create $outputfile and ensure it is empty.
  echo "-------------------#---------#----------------" > $outputfile
  
  # Loop through $descriptions, generate passwords and write details to $outfile
  for i in ${!descriptions[@]}; do
    # Check if we reached the stage of creating host-specific passwords
    if [ "${descriptions[$i]}" = "ESXi Management" ]; then
      break
    fi
    echo "${descriptions[$i]}#${users[$i]}#${defaultpws[$i]}" >> $outputfile
  done

  echo "" >> $outputfile
  echo "Host specific" >> $outputfile
  for (( j=$i; j<${#descriptions[@]}; j++ )); do
    echo "${descriptions[$j]}#${users[$j]}#${defaultpws[$j]}" >> $outputfile
  done
  
  # Display the output file
  column -t -s'#' -N "Account description,User name,Default password" -L $outputfile
  
  deltmpfile
}


### Function to display the help text
helptext () {
cat <<EOF
vxrail-pwgen version $version
Usage: $program [-h | --help] | [-v | --version] | [-d] | [OPTIONS]

  -h, --help       Prints this help text and exits
  -v, --version    Prints the version number and exits
  -d               Prints factory default passwords for all accounts
  
  OPTIONS
  -l=NUM, --length=NUM
          Specify the target password length.
          NUM must be 0 or larger than or equal to a minimum. Default: $defaultchars.
          The minimum is determined by other options specified. To determine the
          lowest possible, use  -l=1  and the program reports the minimum.
          
          All password lengths will be set to specified value, except when the
          target value is too high for a specific account. In that case, the
          maximum password length for the specific account will be used.
          If NUM is 0, the maximum password length for each account is used.
                   
  -n=NUM --numhosts=NUM
          Specify the number of hosts to generate passwords for.
          NUM must be 0 or larger than 0. Default: $numhosts.
          When NUM is larger than 0, passwords for individual hosts will be
          generated.

  -s      Include Dell SmartFabric OS10-based switches in output.
  
  mps=<0|1>
          Management Password Same (MPS)
          Value is either 0 or 1. Default: $esximgmtpwsame
          Specify if the password for the ESXi Management User should be
          different (0) or the same (1) same across hosts in the cluster.

  rps=<0|1>
          Root Password Same (RPS)
          Value is either 0 or 1. Default: $esxirootpwsame
          Specify if the password for the ESXi root user should be
          different (0) or the same (1) same across hosts in the cluster.

  ips=<0|1>
          iDRAC Password Same (IPS)
          Value is either 0 or 1. Default: $idracpwsame
          Specify if the password for the iDRAC root user should be
          different (0) or the same (1) same across hosts in the cluster.

  sps=<0|1>
          Switch Password Same (SPS)
          Value is either 0 or 1. Default: $swpwsame
          Specify if the password for the admin user on Dell SmartFabric OS 10
          switches should be different (0) or the same (1) same across switches
          in the cluster.
          
  vcext=<0|1>
          vCenter Server External
          Value is either 0 or 1. Default: $externalvcenter
          Specify if the vCenter Server is embedded (0) or external (1) to the
          VxRail environment.

This program generates a set of passwords to be used by a VxRail cluster.
All passwords created meet the requirements and restrictions that are provided
by various sources on the internet. The passwords are also script-resistant,
meaning they can be used during a VxRail upgrade process. The passwords should
work with VxRail version 7.x and 8.x.
          
While generating the passwords, a temporary file is used to store the passwords.
This file is automatically removed by calling the shred program. If shred is not
installed, the file will be removed using the rm command and a warning is shown.
EOF
}

### End function to display help text

########## END FUNCTIONS ##########



### Parse command line options

if [[ "$@" == *"-h"* ]] || [[ "$@" == *"--help"* ]]; then
  helptext
  exit
elif [[ "$@" == *"-v"* ]] || [[ "$@" == *"--version"* ]]; then
  echo "vxrail-pwgen $version"
  exit
elif [[ "$@" == *"-d"* ]]; then
  showdefaultpws
  exit
fi


for i in "$@"; do
  case $i in
    -l=*|--length=*)
      defaultchars="${i#*=}"
      shift # past argument=value
      ;;
    -n=*|--numhosts=*)
      numhosts="${i#*=}"
      shift # past argument=value
      ;;
    -s)
      includeswitches=1
      shift # past argument=value
      ;;
    mps=*)
      esximgmtpwsame="${i#*=}"
      shift # past argument=value
      ;;
    rps=*)
      esxirootpwsame="${i#*=}"
      shift # past argument=value
      ;;
    ips=*)
      idracpwsame="${i#*=}"
      shift # past argument=value
      ;;
    sps=*)
      swpwsame="${i#*=}"
      shift # past argument=value
      ;;
    vcext=*)
      externalvcenter="${i#*=}"
      shift # past argument=value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

### End parsing command line options




### Remove relevant entries from $descriptions, $users, $pwlength, $maxpwlength and $minpwlength
### if $externalvcenter=1 and if $includeswitches=0

if [ $externalvcenter = 1 ]; then
  # External vCenter, therefore remove relevant entries from arrays.
  # Get index of the first account to remove and update the arrays
  res=$(getindex "${descriptions[@]}" "VMware vCenter Server root")
  update_arrays $res
  
  # Get index of the second account to remove and update the arrays
  res=$(getindex "${descriptions[@]}" "VMware vCenter Server administrator")
  update_arrays $res
fi

if [ $includeswitches = 0 ]; then
  # No Dell switches, therefore remove relevant entries from arrays.
  # Get index of the first account to remove and update the arrays
  res=$(getindex "${descriptions[@]}" "Dell SmartFabric OS 10 ToR switch 1")
  update_arrays $res
  
  # Get index of the second account to remove and update the arrays
  res=$(getindex "${descriptions[@]}" "Dell SmartFabric OS 10 ToR switch 2")
  update_arrays $res

  # Get index of the third account to remove and update the arrays
  res=$(getindex "${descriptions[@]}" "Dell SmartFabric OS 10 MGMT switch")
  update_arrays $res
fi



### Update pwlength array if required

# Get highest value of the array of minimum password lengths.
minpwlen=$(getarrmax "${minpwlength[@]}")
# Get lowest value of the array of maximum password lengths.
maxpwlen=$(getarrmin "${maxpwlength[@]}")

if [ "$defaultchars" = "0" ]; then
  # Maximum password length requested. Set the maximum password length allowable for each account
  pwlength=("${maxpwlength[@]}")  
elif (( $defaultchars < $minpwlen )); then
  echo "Minimum password length is $minpwlen characters."
  exit
elif (( $defaultchars >= $minpwlen )) && (( $defaultchars <= $maxpwlen )); then
  # Requested password length is allowed by all user accounts.
  declare -a pwlength=("$defaultchars" "$defaultchars" "$defaultchars" \
                       "$defaultchars" "$defaultchars" "$defaultchars" \
                       "$defaultchars" "$defaultchars" "$defaultchars" \
                       "$defaultchars" "$defaultchars" "$defaultchars" )
else
  # Requested password length exceeds certain (or all) accounts.
  endmessage="${endmessage}"$'\n'$"Requested password length exceeds limits of some or all accounts. We limited the"
  endmessage="${endmessage}"$'\n'$"length where required."
  declare -a pwlength=()
  for i in ${!maxpwlength[@]}; do
    # Loop through maximum password length list
    if (( $defaultchars > "$((${maxpwlength[$i]}))" )); then
      # If requested length is larger than the one recorded in the list,
      # limit the length to the maximum length.
      pwlength[$i]=${maxpwlength[$i]}
    else
      # If the requested length equals or is smaller than the one in the list,
      # then set the length to the requested length.
      pwlength[$i]=$defaultchars
    fi
  done
fi

### End updating pwlength array




### Start of script


# Check if pwgen is installed
which pwgen > /dev/null
if [ "$?" != "0" ]; then
  echo "Ensure that pwgen is installed."
  exit 1
fi

# Check if column is installed
which column > /dev/null
if [ "$?" != "0" ]; then
  echo "Ensure that column is installed."
  exit 1
fi

# Create $outputfile and ensure it is empty.
echo "-------------------#---------#--------" > $outputfile

### Process environment-specific passwords

# Create passwords for cases where they need to be the same across switches
if [ $swpwsame = 1 ]; then
  res=$(getindex "${descriptions[@]}" "Dell SmartFabric OS 10 ToR switch 1")
  swadminpw=`genpw ${pwlength[$res]} 1`
fi

# Loop through $descriptions, generate passwords and write details to $outfile
for i in ${!descriptions[@]}; do
  # Ensure vCenter Server administrator password is the same as the
  # vCenter Server root password by recording the same password again.
  if [ "${descriptions[$i]}" = "VMware vCenter Server administrator" ]; then
    echo "${descriptions[$i]}#${users[$i]}#$password" >> $outputfile
    continue
  fi

  password=`genpw ${pwlength[$i]} 1`
  
  # Check if we are providing a switch password and if these need to be the same
  if [[ "${descriptions[$i]}" == "Dell SmartFabric"* ]] && [ $swpwsame = 1 ]; then
    password=$swadminpw
  fi
      
  # Check if we reached the stage of creating host-specific passwords
  if [ "${descriptions[$i]}" = "ESXi Management" ]; then
    break
  fi
  
  echo "${descriptions[$i]}#${users[$i]}#$password" >> $outputfile
done

### Process host-specific passwords.

# Create passwords for cases where they need to be the same across hosts
if [ $esximgmtpwsame = 1 ]; then
  esximgmtpw=`genpw ${pwlength[$i]} 1`
  #echo "ESXi mgmt $esximgmtpw"
fi

if [ $esxirootpwsame = 1 ]; then
  esxirootpw=`genpw ${pwlength[$i+1]} 1`
  #echo "ESXi root $esxirootpw"
fi

if [ $idracpwsame = 1 ]; then
  idracpw=`genpw ${pwlength[$i+2]} 1`
  #echo "iDRAC root $idracpw"
fi

for x in $(seq 1 $numhosts); do
  # Write host header to output file
  echo "" >> $outputfile
  echo "Host $x##" >> $outputfile
  for (( j=$i; j<${#descriptions[@]}; j++ )); do
    # Generate or re-use password and write details to $outfile
    password=`genpw ${pwlength[$j]} 1`
    
    if [ $esximgmtpwsame = 1 ] && [ $j = $(($i + 0)) ]; then
      password=$esximgmtpw
    fi
    if [ $esxirootpwsame = 1 ] && [ $j = $(($i + 1)) ]; then
      password=$esxirootpw
    fi
    if [ $idracpwsame = 1 ] && [ $j = $(($i + 2)) ]; then
      password=$idracpw
    fi

    echo "${descriptions[$j]}#${users[$j]}#$password" >> $outputfile
  done
done

if [ $externalvcenter = 0 ]; then
  endmessage="${endmessage}"$'\n'$"The passwords for 'vCenter Server root' and 'vCenter Server administrator' are"
  endmessage="${endmessage}"$'\n'$"the same. See item 3 in the section 'Password restrictions' of the following URL"
  endmessage="${endmessage}"$'\n'$"which was confirmed to work on 21 June 2024:"
  endmessage="${endmessage}"$'\n'$"https://www.dell.com/support/kbdoc/en-au/000158231/vxrail-account-and-password-rules-in-vxrail"
else
  endmessage="${endmessage}"$'\n'$"The 'vCenter Server management' account (or equivalent) may already exist on the"
  endmessage="${endmessage}"$'\n'$"external vCenter Server. If it does, it would have been used for another VxRail"
  endmessage="${endmessage}"$'\n'$"deployment and should be assigned the 'VMware HCIA Management' role. If the"
  endmessage="${endmessage}"$'\n'$"account does not exist, it will be created during cluster deployment."
fi

# Display the output file
column -t -s'#' -N "Account description,User name,Password" -L $outputfile

echo "$endmessage"

# Get rid of the temporary file.
deltmpfile

exit


: <<'LICENSE'
MIT License

Copyright 2024 Marc van Wieringen, Sydney, Australia

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LICENSE
