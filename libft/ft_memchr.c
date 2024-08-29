/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memchr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/17 15:50:46 by magahat           #+#    #+#             */
/*   Updated: 2024/05/27 13:28:40 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memchr(const void *b, int c, size_t len)
{
	int	i;

	i = 0;
	while (len--)
	{
		if (((unsigned char *)b)[i] == (unsigned char)c)
			return ((void *)(unsigned char *)b + i);
		i++;
	}
	return (NULL);
}