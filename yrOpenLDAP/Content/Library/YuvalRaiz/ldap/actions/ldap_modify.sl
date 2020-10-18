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
  python_action:
    use_jython: false
    script: "import ldap\nimport ldap.modlist\n# do not remove the execute function \ndef execute(ldap_url,ldap_username,ldap_password,dn,attr,new_value): \n  return_code = 0\n  return_result = ''\n  error_message = ''\n  try:\n    con=ldap.initialize(ldap_url)\n    con.simple_bind_s(ldap_username, ldap_password)\n    old_value=con.search_s(dn, ldap.SCOPE_SUBTREE, '(cn=*)')\n    old_value=old_value[0][1][attr]\n    old_obj={attr: old_value}\n    new_obj={attr: [new_value.encode()]}\n    modlist=ldap.modlist.modifyModlist(old_obj,new_obj)\n    \n    modify_result=con.modify_s(dn, modlist)\n    modify_result = \"yuval\"\n    return_result=modify_result\n  except Exception as e:\n    return_code = -1\n    error_message = e\n  return locals()"
  outputs:
    - modify_result
    - error_message
    - return_result
    - return_code
    - old_value
    - query
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
