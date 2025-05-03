import { Component, OnInit } from '@angular/core';
import { CinemaDTO } from '../dtos/cinema.dto';
import { CinemaService } from '../services/cinema.service';
import { Environment } from '../environments/environment';

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

  constructor(private cinemaService: CinemaService) {}

  ngOnInit(): void {
    this.fetchCinemas();
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
}