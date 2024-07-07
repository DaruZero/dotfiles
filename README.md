todo:
- [ ] backup:
  - [ ] ssh keys
  - [ ] gpg keys
  - [ ] fonts
- [ ] `.zprofile` and `.profile` don't need to be invoked from `.zshrc`, as they are loaded during login


shell files structure:

.config/
  shell-common/
    alias.d/
      common
      arch
      debian
      fedora
    function.d/
      common
      arch
      debian
      fedora
  zsh/
    plugins/
    themes/
    completions/
  bash/
    TBD
.profile
.bash_profile
.zprofile
.bashrc
.zshrc
