<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_section_name">
<querytext>
select acs_object.name(:package_id) as title from dual
</querytext>
</fullquery>

</queryset>
