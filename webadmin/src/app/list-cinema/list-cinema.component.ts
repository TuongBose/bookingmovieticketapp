import { Component, OnInit } from '@angular/core';
import { CinemaDTO } from '../dtos/cinema.dto';
import { CinemaService } from '../services/cinema.service';
import { Environment } from '../environments/environment';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { HttpClient } from '@angular/common/http';


@Component({
  selector: 'app-list-cinema',
  standalone: false,
  templateUrl: './list-cinema.component.html',
  styleUrls: ['./list-cinema.component.css']
})
export class ListCinemaComponent implements OnInit {
  cinemas: CinemaDTO[] = [];
  filteredCinemas: CinemaDTO[] = [];
  cities: string[] = [];
  selectedCity: string = 'Toàn quốc';
  errorMessage: string = '';
  isLoading: boolean = true;
  provinces: any[] = [];
  newCinema: CinemaDTO = new CinemaDTO();
  selectedImage: File | null = null;

  @ViewChild('addCinemaModal') addCinemaModal!: TemplateRef<any>;

  constructor(private cinemaService: CinemaService, private http: HttpClient, private modalService: NgbModal) {}

  ngOnInit(): void {
    this.fetchCinemas();
    this.fetchProvinces();
  }

  fetchCinemas(): void {
    this.isLoading = true;
    this.cinemaService.getAllCinema().subscribe({
      next: (cinemas) => {
        this.cinemas = cinemas;
        this.getUniqueCities();
        this.filterCinemas(); // Lọc rạp ngay sau khi lấy dữ liệu
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error fetching cinemas:', error);
        this.errorMessage = 'Không thể tải danh sách rạp chiếu phim.';
        this.isLoading = false;
      },
    });
  }

fetchProvinces(): void {
    this.http.get<any[]>('https://provinces.open-api.vn/api/?depth=2').subscribe({
      next: (data) => {
        this.provinces = data.map(province => ({
          code: province.code,
          name: province.name,
          districts: province.districts // Lưu thông tin quận/huyện nếu cần
        }));
      },
      error: (error) => {
        console.error('Error fetching provinces:', error);
        this.errorMessage = 'Không thể tải danh sách thành phố.';
      }
    });
  }

  getUniqueCities(): void {
    this.cities = [...new Set(this.cinemas.map(cinema => cinema.city))];
    this.cities.unshift('Toàn quốc');
  }

  filterCinemas(): void {
    if (this.selectedCity === 'Toàn quốc') {
      this.filteredCinemas = [...this.cinemas];
    } else {
      this.filteredCinemas = this.cinemas.filter(cinema => cinema.city === this.selectedCity);
    }
  }

  getCinemaImageUrl(cinemaId: number, imagename: string): string {
    return imagename && imagename !== 'no_image' ? `${Environment.apiBaseUrl}/cinemas/${cinemaId}/image` : 'assets/images/no_image.jpg';
  }

  onImageError(event: Event, cinemaId: number): void {
    const imgElement = event.target as HTMLImageElement;
    imgElement.src = 'assets/images/no_image.jpg'; // Chuyển sang hình mặc định khi lỗi
    console.warn(`Failed to load image for cinema ID ${cinemaId}, using default image.`);
  }

  openAddCinemaModal(): void {
    this.newCinema = new CinemaDTO(); // Reset form
    this.selectedImage = null;
    this.modalService.open(this.addCinemaModal, { ariaLabelledBy: 'modal-basic-title' });
  }

  onImageSelected(event: any): void {
    this.selectedImage = event.target.files[0] as File;
    this.newCinema.imagename = this.selectedImage ? this.selectedImage.name : null;
  }

  addCinema(): void {
    if (!this.newCinema.name || !this.newCinema.city || !this.newCinema.coordinates || 
        !this.newCinema.address || !this.newCinema.phonenumber || !this.newCinema.maxroom) {
      this.errorMessage = 'Vui lòng điền đầy đủ thông tin.';
      return;
    }

    const formData = new FormData();
    formData.append('name', this.newCinema.name);
    formData.append('city', this.newCinema.city);
    formData.append('coordinates', this.newCinema.coordinates);
    formData.append('address', this.newCinema.address);
    formData.append('phonenumber', this.newCinema.phonenumber);
    formData.append('maxroom', this.newCinema.maxroom.toString());
    if (this.selectedImage) {
      formData.append('image', this.selectedImage);
    }

    this.cinemaService.createCinema(formData).subscribe({
      next: (response) => {
        this.fetchCinemas(); // Làm mới danh sách rạp
        this.modalService.dismissAll(); // Đóng modal
        this.errorMessage = 'Thêm rạp thành công!';
        setTimeout(() => this.errorMessage = '', 3000); // Xóa thông báo sau 3 giây
      },
      error: (error) => {
        console.error('Error adding cinema:', error);
        this.errorMessage = 'Lỗi khi thêm rạp: ' + (error.error?.error || error.message);
      }
    });
  }
}