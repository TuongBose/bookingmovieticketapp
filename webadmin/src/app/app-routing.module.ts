import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { MovieListComponent } from './movie-list/movie-list.component';
import { CinemaListComponent } from './cinema-list/cinema-list.component';
import { ShowtimeListComponent } from './showtime-list/showtime-list.component';
import { CustomerListComponent } from './customer-list/customer-list.component';
import { AdminListComponent } from './admin-list/admin-list.component';
import { LoginComponent } from './login/login.component';
import { AuthGuard } from './guard/auth.guard';

const routes: Routes = [
  {path: 'login', component: LoginComponent},
  {
    path: '',
    component: HomeComponent,
    canActivate: [AuthGuard],
    children: [
      { path: 'movies', component: MovieListComponent },
      { path: 'cinemas', component: CinemaListComponent },
      { path: 'showtimes', component: ShowtimeListComponent },
      { path: 'customers', component: CustomerListComponent },
      { path: 'admins', component: AdminListComponent },
      { path: '', redirectTo: 'movies', pathMatch: 'full' } // Mặc định hiển thị Quản lý phim
    ]
  },
  { path: '**', redirectTo: '' } // Chuyển hướng về trang chính nếu đường dẫn không tồn tại
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }