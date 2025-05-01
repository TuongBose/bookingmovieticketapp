import { Component, OnInit } from '@angular/core';
import { CinemaDTO } from '../dtos/cinema.dto';
import { CinemaService } from '../services/cinema.service';

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

  constructor(private cinemaService: CinemaService) {}

  ngOnInit(): void {
    this.fetchCinemas();
  }

  fetchCinemas(): void {
    this.cinemaService.getAllCinema().subscribe({
      next: (cinemas) => {
        this.cinemas = cinemas;
        this.getUniqueCities();
        this.filterCinemas(); // Lọc rạp ngay sau khi lấy dữ liệu
      },
      error: (error) => {
        console.error('Error fetching cinemas:', error);
        this.errorMessage = 'Không thể tải danh sách rạp chiếu phim.';
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
}