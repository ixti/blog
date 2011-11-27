var path = require('path'), i, l;

for (i = 0, l = 100000; i <= l; i++) {
  path.existsSync('/nonsense');
}
