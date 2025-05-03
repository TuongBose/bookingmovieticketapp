// src/app/services/movie.service.ts
import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, map, retry, timeout } from 'rxjs/operators';
import { Environment } from '../environments/environment';
import { CinemaDTO } from '../dtos/cinema.dto';

@Injectable({
  providedIn: 'root',
})
export class CinemaService {
  constructor(private http: HttpClient) {}

  getAllCinema(): Observable<CinemaDTO[]> {
    const headers = new HttpHeaders()
      .set('Content-Type', 'application/json')
      .set('Accept', 'application/json');
    return this.http.get<any>(`${Environment.apiBaseUrl}/cinemas`, { headers: headers, withCredentials: true }).pipe(
      timeout(5000),
      retry(1),
      map(response => this.mapToCinemas(response)), // Backend đã trả về danh sách phim, không cần response.results
      catchError(this.handleError)
    );
  }

  getCinemaImage(cinemaId: number): Observable<Blob> {
    return this.http.get(`${Environment.apiBaseUrl}/cinemas/${cinemaId}/image`, {
      responseType: 'blob'
    }).pipe(
      timeout(5000),
      retry(1),
      catchError(this.handleError)
    );
  }

  private mapToCinemas(apiCinemas: any[]): CinemaDTO[] {
    return apiCinemas.map(cinema => ({
        id: cinema.id || 0,
        name: cinema.name || 'Unknown Title',
        city: cinema.city || 'Unknown City',
        coordinates: cinema.coordinates || 'Unknown Coordinates',
        address: cinema.address || 'Unknown Address',
        phonenumber: cinema.phonenumber || 'Unknown Phone Number',
        maxroom: cinema.maxroom || 0,
        imagename: cinema.imagename || 'no_image',
    }));
  }

  private handleError(error: HttpErrorResponse) {
    console.error('An error occurred:', error);

    if (error.status === 0) {
      return throwError(() => 'Connection to server failed. Please check if the backend is running.');
    }

    const errorMessage = error.error?.message || error.message || 'Unknown error occurred';
    return throwError(() => errorMessage);
  }
}