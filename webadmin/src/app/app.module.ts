import { NgModule } from '@angular/core';
import { BrowserModule, provideClientHydration, withEventReplay } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { MovieListComponent } from './movie-list/movie-list.component';
import { CinemaListComponent } from './cinema-list/cinema-list.component';
import { ShowtimeListComponent } from './showtime-list/showtime-list.component';
import { CustomerListComponent } from './customer-list/customer-list.component';
import { AdminListComponent } from './admin-list/admin-list.component';

@NgModule({
  declarations: [
    LoginComponent,
    HomeComponent,
    MovieListComponent,
    CinemaListComponent,
    ShowtimeListComponent,
    CustomerListComponent,
    AdminListComponent
  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [
    provideClientHydration(withEventReplay())
  ],
  bootstrap: [HomeComponent]
})
export class AppModule { }
