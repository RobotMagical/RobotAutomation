*** Settings ***
Library           DatabaseLibrary
Resource          ../resources/common_func.resource

*** Keywords ***
DB CONNECT
    Log    initiate databse connection
    Connect To Database Using Custom Params        cx_Oracle        '${DBUser}/${DBPass}@${DBHost}:${DBPort}/${DBSID}'

DB DISCONNECT
    Disconnect From Database
    Log    Disconnected successfully

Verify Query - Row Count rateplan table
    @{output} =    Query    SELECT COUNT(*) FROM rateplan
    Log    ${output[0][0]}
    [Return]     ${output[0][0]}

Verify Query - Customer_all table
    @{output} =     Query    select * from customer_all where custcode='1.27903001'
    Log    ${output[0][0]}
    Log To Console    ${output[0][0]}


Validate record in customer_all table
    [Arguments]    ${customerid}
    Row Count is Equal to X    select * from customer_all where custcode='${customerid}'    1    True

Create VPN Entry in database
    [Arguments]   ${vpn_name}   ${vpn_pub_name}

    #${rowCount}=	Row Count	select * from sysadm.directory_number where dn_num='${vpn_pub_name}'
    ${RandomVal}=  Query  select max_RA_DN_ID_seq.nextval from dual
    ${UpdateVPNQuery}=  set variable   update sysadm.directory_number_vpn set dn_id='${RandomVal[0][0]}',dn_num='${vpn_pub_name}', dealer_id='-3', vpn_id=(select vpn_id from sysadm.virtual_private_network where vpn_name='${vpn_name}')

    Execute Sql String    ${UpdateVPNQuery}
    Execute Sql String   insert into sysadm.directory_number select * from sysadm.directory_number_vpn

Validate record in directory number table
    [Arguments]    ${dn_name}
    Row Count is Equal to X    select * from sysadm.directory_number where dn_num='${dn_name}'   1  True

Get Consumer SIM from database

    ${selectSIMQuery}=  Catenate	SEPARATOR=\n
    ...  select s.sm_serialnum from storage_medium s,port p where s.sm_status='r' and s.sm_id =p.sm_id and p.port_status='r'
    ...  and p.port_num not in (select port_num from EMCDU.MAT_REQUEST_ALL where status='N' and port_num is not null)
    ...  and p.dealer_id=-14
    ...  and s.dealer_id=-14 and s.smc_id in ('3')
    ...  and s.rec_version = '1'
    ...  and port_num like '4240300%'
    ...  order by SM_STATUS_MOD_DATE desc

    @{simlist} =    Query    SELECT * FROM (${selectSIMQuery}) where rownum <= 10
    Log To Console    ${simlist[5][0]}
    [Return]  ${simlist[5][0]}


Get Consumer MSISDN from database

    ${selectMSISDNQuery}=  Catenate	SEPARATOR=\n
    ...  select DN_NUM from directory_number where
    ...  DN_STATUS='r' and DN_ASSIGN_DATE is null
    ...  and dn_num not in (select dn_num from pre_launch)
    ...  and dn_num not in (select msisdn from EMCDU.MAT_REQUEST_ALL where status='N' and msisdn is not null)
    ...  and length(DN_NUM)=12 and DEALER_ID='-14' and HLCODE=1 and NDC=55 and DIRNUM_NPCODE=1
    ...  and dn_num like '971559%'
    ...  order by DN_STATUS_MOD_DATE desc

    @{dirnumlist} =    Query    SELECT * FROM (${selectMSISDNQuery}) where rownum <= 10
    [Return]  ${dirnumlist[5][0]}

Get Enterprise SIM from database

    ${selectSIMQuery}=  Catenate	SEPARATOR=\n
    ...  select s.sm_serialnum from storage_medium s,port p where s.sm_status='r' and s.sm_id =p.sm_id and p.port_status='r'
    ...  and p.port_num not in (select port_num from EMCDU.MAT_REQUEST_ALL where status='N' and port_num is not null)
    ...  and p.dealer_id=-3
    ...  and s.dealer_id=-3 and s.smc_id in ('3')
    ...  and s.rec_version = '1'
    ...  and port_num like '4240300%'
    ...  order by SM_STATUS_MOD_DATE desc

    @{simlist} =    Query    SELECT * FROM (${selectSIMQuery}) where rownum <= 10
    Log To Console    ${simlist[5][0]}
    [Return]  ${simlist[5][0]}

Get Enterprise MSISDN from database

    ${selectMSISDNQuery}=  Catenate	SEPARATOR=\n
    ...  select DN_NUM from directory_number where
    ...  DN_STATUS='r' and DN_ASSIGN_DATE is null
    ...  and dn_num not in (select dn_num from pre_launch)
    ...  and dn_num not in (select msisdn from EMCDU.MAT_REQUEST_ALL where status='N' and msisdn is not null)
    ...  and length(DN_NUM)=12 and DEALER_ID='-14' and HLCODE=1 and NDC=55 and DIRNUM_NPCODE=1
    ...  and dn_num like '971559%'
    ...  order by DN_STATUS_MOD_DATE desc

    @{dirnumlist} =    Query    SELECT * FROM (${selectMSISDNQuery}) where rownum <= 10
    [Return]  ${dirnumlist[5][0]}

Get Consumer SIM with POS dealer id from database

    ${selectSIMQuery}=  Catenate	SEPARATOR=\n
    ...  select s.sm_serialnum from storage_medium s,port p,emcdu.STORAGE_MEDIUM_POS_DEALER ps where s.sm_status='r' and s.sm_id =p.sm_id and p.port_status='r'
    ...  and s.sm_serialnum = PS.SIM_SERIAL
    ...  and p.port_num not in (select port_num from EMCDU.MAT_REQUEST_ALL where status='N' and port_num is not null)
    ...  and p.dealer_id=-14
    ...  and s.dealer_id=-14 and s.smc_id in ('3')
    ...  and s.rec_version = '1'
    ...  and port_num like '4240300%'
    ...  order by SM_STATUS_MOD_DATE desc

    @{simlist} =    Query    SELECT * FROM (${selectSIMQuery}) where rownum <= 5
    Log To Console    ${simlist[3][0]}
    [Return]  ${simlist[3][0]}

Get Enterprise SIM with POS dealer id from database

    ${selectSIMQuery}=  Catenate	SEPARATOR=\n
    ...  select s.sm_serialnum from storage_medium s,port p,emcdu.STORAGE_MEDIUM_POS_DEALER ps where s.sm_status='r' and s.sm_id =p.sm_id and p.port_status='r'
    ...  and s.sm_serialnum = PS.SIM_SERIAL
    ...  and p.port_num not in (select port_num from EMCDU.MAT_REQUEST_ALL where status='N' and port_num is not null)
    ...  and p.dealer_id=-3
    ...  and s.dealer_id=-3 and s.smc_id in ('3')
    ...  and s.rec_version = '1'
    ...  and port_num like '4240300%'
    ...  order by SM_STATUS_MOD_DATE desc

    @{simlist} =    Query    SELECT * FROM (${selectSIMQuery}) where rownum <= 5
    Log To Console    ${simlist[3][0]}
    [Return]  ${simlist[3][0]}


Get POS dealer id
    [Arguments]    ${SIM}

    @{posdealer_value} =    Query    select pos_dealer_id from emcdu.STORAGE_MEDIUM_POS_DEALER where SIM_SERIAL='${SIM}'
    Log To Console    POS delaer id : ${posdealer_value[0][0]}
    [Return]  ${posdealer_value[0][0]}
