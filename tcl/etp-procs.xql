<?xml version="1.0"?>
<queryset>

<fullquery name="etp::define_content_type.object_type_exists">      
<querytext>
	select 1 from acs_object_types
	 where object_type = :content_type
</querytext>
</fullquery>

<fullquery name="etp::define_content_type.attribute_exists">      
<querytext>
	    select attribute_id from acs_attributes
	     where object_type = :content_type
	       and attribute_name = :a_name
</querytext>
</fullquery>

</queryset>
