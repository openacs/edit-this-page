<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_revisions">
<querytext>

select o.creation_user as creation_user_id,
       person.name(o.creation_user) as creation_user_name,
       to_char(o.creation_date, 'Mon DD') as creation_date,
       o.modifying_user as publish_user_id, 
       person.name(o.modifying_user) as publish_user_name,
       to_char(r.publish_date, 'Mon DD') as publish_date,
       r.revision_id, 
       content_revision.get_number(r.revision_id) as version_number
from cr_revisions r, cr_items i, acs_objects o
where r.item_id = i.item_id
and o.object_id = r.revision_id
and i.parent_id = etp.get_folder_id(:package_id)
and i.name = :name
order by r.revision_id

</querytext>
</fullquery>
 
</queryset>
