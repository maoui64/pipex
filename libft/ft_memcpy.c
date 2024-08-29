/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memcpy.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/17 12:16:40 by magahat           #+#    #+#             */
/*   Updated: 2024/05/27 11:08:06 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memcpy(void *dst, const void *src, size_t len)
{
	void	*tmp;

	tmp = dst;
	if (!dst && !src)
		return (dst);
	while (len--)
		*(char *)dst++ = *(const char *)src++;
	return (tmp);
}
