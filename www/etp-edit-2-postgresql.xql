<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_new_revision">
<querytext>
select etp__create_new_revision(:package_id, :name, :user_id);
</querytext>
</fullquery>
 
</queryset>
