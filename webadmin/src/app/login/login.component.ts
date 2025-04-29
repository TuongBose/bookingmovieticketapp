import { Component, Inject, PLATFORM_ID } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { privateDecrypt } from 'crypto';
import { isPlatformBrowser } from '@angular/common';

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

  constructor(
    private router: Router, 
    private authService: AuthService,
    @Inject (PLATFORM_ID) private platformId: Object
  ) {}

  login(): void {
    const userLoginDTO = {
      phonenumber: this.phonenumber,
      password: this.password,
    };
    this.authService.login(userLoginDTO).subscribe({
      next: (response) => {
        this.authService.setUser(response);
        if (isPlatformBrowser(this.platformId)){
        this.router.navigate(['/home']);
      }},
      error: (error) => {
        this.errorMessage =
          error.error || 'Dang nhap that bai vui long kiem tra lai thong tin';
        console.error('Login error', error);
      },
    });
  }
}
