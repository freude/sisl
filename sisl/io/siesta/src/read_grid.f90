subroutine read_grid_sizes(fname, nspin, mesh)
  
  implicit none

  ! Precision 
  integer, parameter :: sp = selected_real_kind(p=6)
  integer, parameter :: dp = selected_real_kind(p=15)
  real(dp), parameter :: eV = 13.60580_dp
  real(dp), parameter :: Ang = 0.529177_dp

  ! Input parameters
  character(len=*), intent(in) :: fname
  integer, intent(out) :: nspin
  integer, intent(out) :: mesh(3)

! Define f2py intents
!f2py intent(in) :: fname
!f2py intent(out) :: nspin
!f2py intent(out) :: mesh

! Internal variables and arrays
  integer :: iu

  call free_unit(iu)
  open(iu,file=trim(fname),status='old',form='unformatted')

  read(iu) ! cell(:,:)

  read(iu) mesh, nspin

  close(iu)

end subroutine read_grid_sizes

subroutine read_grid_cell(fname, cell)

  implicit none
  
  ! Precision 
  integer, parameter :: sp = selected_real_kind(p=6)
  integer, parameter :: dp = selected_real_kind(p=15)
  real(dp), parameter :: eV = 13.60580_dp
  real(dp), parameter :: Ang = 0.529177_dp

  ! Input parameters
  character(len=*), intent(in):: fname
  real(dp), intent(out) :: cell(3,3)
  
! Define f2py intents
!f2py intent(in) :: fname
!f2py intent(out) :: cell

! Internal variables and arrays
  integer :: iu

  call free_unit(iu)
  open(iu,file=trim(fname),status='old',form='unformatted')

  read(iu) cell(:,:)
  cell = cell * Ang

  close(iu)

end subroutine read_grid_cell

subroutine read_grid(fname, nspin, mesh1, mesh2, mesh3, grid)

  implicit none

  ! Precision 
  integer, parameter :: sp = selected_real_kind(p=6)
  integer, parameter :: dp = selected_real_kind(p=15)
  real(dp), parameter :: Ang = 0.529177_dp

  ! Input parameters
  character(len=*), intent(in) :: fname
  integer, intent(in) :: nspin, mesh1, mesh2, mesh3
  real(sp), intent(out) :: grid(mesh1,mesh2,mesh3,nspin)
  
! Define f2py intents
!f2py intent(in) :: fname
!f2py intent(in) :: nspin, mesh1, mesh2, mesh3
!f2py intent(out) :: cell, grid

! Internal variables and arrays
  integer :: iu
  integer :: is, iz, iy

  ! Local readables
  integer :: lnspin, lmesh(3)

  call free_unit(iu)
  open(iu,file=trim(fname),status='old',form='unformatted')

  read(iu) ! cell

  read(iu) lmesh, lnspin
  if ( lnspin /= nspin ) stop 'Error in reading data, not allocated, nspin'
  if ( lmesh(1) /= mesh1 ) stop 'Error in reading data, not allocated, mesh'
  if ( lmesh(2) /= mesh2 ) stop 'Error in reading data, not allocated, mesh'
  if ( lmesh(3) /= mesh3 ) stop 'Error in reading data, not allocated, mesh'

  do is = 1, nspin

     do iz = 1, mesh3
        do iy = 1, mesh2
           read(iu) grid(:,iy,iz,is)
        end do
     end do
     
  end do

  close(iu)

end subroutine read_grid


