<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_section_name">
<querytext>
select acs_object__name(:package_id) as title
</querytext>
</fullquery>

</queryset>
