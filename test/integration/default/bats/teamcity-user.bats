#!/usr/bin/env bats

@test 'teamcity user is created' {
    run curl 'http://localhost:8111/httpAuth/app/rest/users' --basic --user teamcity:teamcity
    [ $status -eq 0 ]
    [ $(echo $output | grep -c "teamcity") -eq 1 ]
}

