<master src="etp-master">
 <property name="title">Confirm revert operation for @name;noquote@</property>

<p>
  Are you sure you want to delete version @version_number@?
</p>

<form method="post" action="etp-revision-delete">
  @form_vars;noquote@
  <input type="submit" value="Yes, I'm sure">
</form>

