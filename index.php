<?php
   if(isset($_POST['submit'])) {
      echo("Username: " . $_POST['username'] . "<br />\n");
      echo("Password: " . $_POST['password'] . "<br />\n");
   }
?>

<h1>Your IP address is <?php echo($_SERVER['REMOTE_ADDR']);?></h1> 
<form action="index.php" method="post">
   <p>Username: <input type="text" name="username" /></p>
   <p>Password: <input type="password" name="password" /></p>
   <input type="submit" name="submit" value="Login" />
</form>
