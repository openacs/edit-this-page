<master src="etp-master">
<property name="title">#edit-this-page.lt_Confirm_revert_operat#</property>
#edit-this-page.lt_Are_you_sure_you_want_1# <b>
<if @revision_count@ eq 1>
#edit-this-page.most_recent_version#
</if>
<else>
#edit-this-page.lt_revision_count_more_recent_versions# 
</else>
#edit-this-page.will_be_deleted#</b>.
<p>
<form method="post" action="etp-revert">
@form_vars;noquote@
<input type="submit" value="Yes, I'm sure">
</form>


