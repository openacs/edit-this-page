<?xml version="1.0"?>
<queryset>

<fullquery name="old_package_parameters">
<querytext>

select attr_value, parameter_id
  from apm_parameter_values 
 where package_id = :curr_package_id

</querytext>
</fullquery>

<fullquery name="copy_parameter">
<querytext>

update apm_parameter_values 
set attr_value = :attr_value
where package_id = :new_package_id
and parameter_id = :parameter_id

</querytext>
</fullquery>


<fullquery name="get_subtopic_application">
<querytext>

select v.attr_value as subtopic_application
  from apm_parameter_values v, apm_parameters p
 where v.parameter_id = p.parameter_id
   and v.package_id = :curr_package_id
   and p.parameter_name = 'subtopic_application'

</querytext>
</fullquery>

<fullquery name="get_application_parameter_id">
<querytext>

select parameter_id
  from apm_parameters p
 where p.parameter_name = 'application'
   and package_key = 'editthispage'

</querytext>
</fullquery>

<fullquery name="set_subtopic_application">
<querytext>

update apm_parameter_values 
set attr_value = :subtopic_application
where package_id = :new_package_id
and parameter_id = :parameter_id

</querytext>
</fullquery>
 
</queryset>
