import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: false,
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  phonenumber: string = '';
  password: string = '';
  errorMessage: string = '';

  constructor(private router: Router, private authService: AuthService) {}

  login(): void {
    const userLoginDTO = {
      phonenumber: this.phonenumber,
      password: this.password,
    };
    this.authService.login(userLoginDTO).subscribe({
      next: (user) => {
        this.authService.setUser(user);
        this.router.navigate(['']);
      },
      error: (error) => {
        this.errorMessage =
          error.error || 'Dang nhap that bai vui long kiem tra lai thong tin';
        console.error('Login error', error);
      },
    });
  }
}
