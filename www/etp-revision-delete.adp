<master src="etp-master">
 <property name="title">Confirm revert operation for @name@</property>

<p>
  Are you sure you want to delete version @version_number@?
</p>

<form method="post" action="etp-revision-delete">
  @form_vars@
  <input type="submit" value="Yes, I'm sure">
</form>

