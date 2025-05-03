import { Component, OnInit } from '@angular/core';
import { UserService } from '../services/user.service';
import { UserDTO } from '../dtos/user.dto';

@Component({
  selector: 'app-list-customer',
  standalone: false,
  templateUrl: './list-customer.component.html',
  styleUrls: ['./list-customer.component.css']
})
export class ListCustomerComponent implements OnInit {
  customers: UserDTO[] = [];
  isLoading: boolean = false;
  errorMessage: string | null = null;
  successMessage: string | null = null;

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadCustomers();
  }

  loadCustomers(): void {
    this.isLoading = true;
    this.errorMessage = null;
    this.successMessage = null;

    this.userService.getAllUserCustomer().subscribe({
      next: (customers) => {
        this.customers = customers;
        this.isLoading = false;
        console.log('[ListCustomerComponent] Đã nhận danh sách customer:', this.customers);
      },
      error: (error: any) => {
        this.errorMessage = error.message || 'Không thể tải danh sách customer';
        this.isLoading = false;
        console.error('[ListCustomerComponent] Lỗi khi lấy danh sách customer:', error);
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
        console.log(`[ListCustomerComponent] Đã cập nhật trạng thái user ${user.id}:`, response);
      },
      error: (error: any) => {
        this.errorMessage = error.error?.error || 'Không thể cập nhật trạng thái user';
        this.isLoading = false;
        console.error(`[toggleUserCustomerIsActive] Lỗi khi cập nhật trạng thái UserCustomer:`, error);
      }
    });
  }
}