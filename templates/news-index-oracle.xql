<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

   <partialquery name="archive_where_clause">
      <querytext>
         sysdate between to_date(attributes.release_date, 'YYYY-MM-DD') and
           to_date(attributes.archive_date, 'YYYY-MM-DD')
      </querytext>
   </partialquery>

   <partialquery name="no_archive_where_clause">
      <querytext>
         sysdate >= to_date(attributes.archive_date, 'YYYY-MM-DD')
      </querytext>
   </partialquery>

   <partialquery name="orderby_clause">
      <querytext>
         to_date(attributes.release_date, 'YYYY-MM-DD') desc
      </querytext>
   </partialquery>
</queryset>
