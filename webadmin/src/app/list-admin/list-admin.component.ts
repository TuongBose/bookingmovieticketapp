import { Component } from '@angular/core';
import { UserService } from '../services/user.service';
import { UserDTO } from '../dtos/user.dto';

@Component({
  selector: 'app-list-admin',
  standalone: false,
  templateUrl: './list-admin.component.html',
  styleUrl: './list-admin.component.css'
})
export class ListAdminComponent {
  admins: UserDTO[] = [];
  isLoading: boolean = false;
  errorMessage: string | null = null;
  successMessage: string | null = null;
  currentUser: UserDTO | null = null;

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.currentUser = this.userService.getUser();
    this.loadAdmins();
  }

  loadAdmins(): void {
    this.isLoading = true;
    this.errorMessage = null;
    this.successMessage = null;

    this.userService.getAllUserAdmin().subscribe({
      next: (admins) => {
        this.admins = admins;
        this.isLoading = false;
        console.log('[ListAdminComponent] Đã nhận danh sách admin:', this.admins);
      },
      error: (error: any) => {
        this.errorMessage = error.message || 'Không thể tải danh sách admin';
        this.isLoading = false;
        console.error('[ListAdminComponent] Lỗi khi lấy danh sách admin:', error);
      }
    });
  }

  toggleActiveStatus(user: UserDTO): void {
    this.isLoading = true;
    this.errorMessage = null;
    this.successMessage = null;

    this.userService.updateUserStatus(user.id, !user.isactive).subscribe({
      next: (response) => {
        user.isactive = !user.isactive; // Cập nhật trạng thái ngay lập tức
        this.successMessage = response.message || 'Cập nhật trạng thái thành công';
        this.isLoading = false;
        console.log(`[ListAdminComponent] Đã cập nhật trạng thái user ${user.id}:`, response);
      },
      error: (error: any) => {
        this.errorMessage = error.error?.error || 'Không thể cập nhật trạng thái user';
        this.isLoading = false;
        console.error(`[toggleUserCustomerIsActive] Lỗi khi cập nhật trạng thái UserAdmin:`, error);
      }
    });
  }

  isCurrentUser(id: number): boolean {
     if(this.currentUser && this.currentUser.id === id)
        return true;
      else return false;
  }
}
