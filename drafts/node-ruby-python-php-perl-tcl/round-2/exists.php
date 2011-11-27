<?php
for ($i = 0, $l = 100000; $i < $l; $i++) {
  file_exists('/nonsense');
}
