<?xml version="1.0"?>
<queryset>

<fullquery name="transform_date">
<querytext>
select to_char($date_string, :date_format)
from dual
</querytext>
</fullquery>

<fullquery name="update_attribute">
<querytext>
update cr_revisions
set $attribute = :value
$extra_sql
where revision_id = :revision_id
</querytext>
</fullquery>
 
<fullquery name="delete_ext_attribute">
<querytext>
delete from acs_attribute_values
where object_id = :revision_id
and attribute_id = :attribute_id
</querytext>
</fullquery>

<fullquery name="insert_ext_attribute">
<querytext>
insert into acs_attribute_values (object_id, attribute_id, attr_value)
values (:revision_id, :attribute_id, :value)
</querytext>
</fullquery>

<fullquery name="update_package_instance_name">
<querytext>
update apm_packages
set instance_name = :value
where package_id = :package_id
</querytext>
</fullquery>

</queryset>
