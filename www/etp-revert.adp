<master src="etp-master">
<property name="title">Confirm revert operation for @name@</property>
Are you sure you want to go back to version @version_number@?
In order to do so, the <b>
<if @revision_count@ eq 1>
most recent version
</if>
<else>
@revision_count@ more recent versions 
</else>
will be deleted</b>.
<p>
<form method="post" action="etp-revert">
@form_vars@
<input type="submit" value="Yes, I'm sure">
</form>

