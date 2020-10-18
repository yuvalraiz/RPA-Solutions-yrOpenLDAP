########################################################################################################################
#!!
#! @input activity: new,add,delete
#!!#
########################################################################################################################
namespace: YuvalRaiz.ldap.actions
operation:
  name: ldap_modify
  inputs:
    - ldap_url
    - ldap_username
    - ldap_password:
        sensitive: true
    - dn
    - attr
    - new_value
    - activity
  python_action:
    use_jython: false
    script: "import ldap\nimport ldap.modlist\n# do not remove the execute function \ndef execute(ldap_url,ldap_username,ldap_password,dn,attr,new_value,activity): \n  return_code = 0\n  return_result = ''\n  error_message = ''\n  try:\n    con=ldap.initialize(ldap_url)\n    con.simple_bind_s(ldap_username, ldap_password)\n    old_val=con.search_s(dn, ldap.SCOPE_BASE, '(cn=*)')\n    old_val=old_val[0][1][attr]\n    old_obj={attr: old_val}\n    tst='x'\n    if activity == 'add':\n      new_val=old_val.copy()\n      tst=old_val\n      new_val+=[new_value.encode()]\n      new_obj={attr: new_val}\n    elif activity == 'delete':\n      new_val=old_val.copy()\n      new_val.remove(new_value.encode())\n      new_obj={attr: new_val}\n    elif activity == 'new':\n      new_val=new_value.encode()\n      new_obj={attr: [new_value.encode()]}\n    else:\n      new_val=old_val\n      new_obj=old_obj\n    \n    modlist=ldap.modlist.modifyModlist(old_obj,new_obj)\n    \n    modify_result=con.modify_s(dn, modlist)\n    return_result=modify_result\n  except Exception as e:\n    return_code = -1\n    error_message = e\n  return locals()"
  outputs:
    - modify_result
    - error_message
    - return_result
    - return_code
    - old_val
    - new_val
    - new_obj
    - tst
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
