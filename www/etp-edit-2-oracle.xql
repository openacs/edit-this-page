<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_new_revision">
<querytext>
begin
  etp.create_new_revision(:package_id, :name, :user_id) from dual;
end;
</querytext>
</fullquery>
 
</queryset>
