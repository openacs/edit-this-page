<?xml version="1.0"?>
<queryset>

<fullquery name="set_app_param">
<querytext>

	update apm_parameter_values
           set attr_value = :app
         where package_id = :package_id
           and parameter_id = (select parameter_id
                                 from apm_parameters
                                where package_key=(select package_key 
                                                     from apm_packages
                                                    where package_id = :package_id)
                                  and parameter_name = 'application')

</querytext>
</fullquery>

<fullquery name="set_subtopic_app_param">
<querytext>

	update apm_parameter_values
           set attr_value = :subtopic_app
         where package_id = :package_id
           and parameter_id = (select parameter_id
                                 from apm_parameters p
                                where package_key=(select package_key 
                                                     from apm_packages
                                                    where package_id = :package_id)
                                  and parameter_name = 'subtopic_application')

</querytext>
</fullquery>
 
</queryset>
